// Author: Zander Venter - zander.venter@nina.no

// Workflow in this script:
  // 1. Setup global environment: Import ecossytem reference polygons generated in R,
    // SSB grid, FKB buildings, LiDAR, AR5, clear-cut data
  // 2. Export data coverage CSV for visualization in R
  // 3. Extract sample of vegetationheights for NiN reference and AR5 polygons


/*
  // 1. Setup global environment ///////////////////////////////////////////////////////////////////////////////
*/

// Geometries for debugging
var geometry = 
    /* color: #d63000 */
    /* shown: false */
    ee.Geometry.Point([10.913510914527835, 60.03670256866523]),
    geometry2 = 
    /* color: #98ff00 */
    /* shown: false */
    ee.Geometry.MultiPoint(
        [[11.022080131331995, 59.94877591779931],
         [11.00148076609762, 59.997223922250754],
         [11.080444999496057, 60.00374695882402],
         [11.201294608871057, 59.99688056890364]]);

// Dictionary to inform the AR5 area code types
var artypeDict = {
 'Bebygd': 11,
 'Ferskvann': 81,
 'Fulldyrka jord': 21,
 'Hav': 82,
 'Ikke kartlag': 99,
 'Innmarksbeite': 23,
 'Myr': 60,
 'Overflatedyrka jord': 22,
 'Samferdsel': 12,
 'Skog': 30,
 'Snøisbre': 70,
 'Åpen fastmark': 50
}

// Set the map to satellite image and add a background layer for viz purposes
Map.setOptions('HYBRID')
Map.addLayer(ee.Image(1), {palette:['white']}, 'white background', 0)

// Color pallete for veg heights
var virdis = '440154,472878,3E4A89,31688E,25838E,1E9E89,35B779,6CCE59,B5DE2C,FDE725';

// Import 5 regions shapefile
var regions = ee.FeatureCollection('users/zandersamuel/NINA/Vector/Norway_administrative_regions_2022');
regions = regions.select(['id'])

// Import SSB grid 
var grid = ee.FeatureCollection('users/zandersamuel/NINA/Vector/Norway_SSB_grid_10km')
grid = grid.select(['ssbid'], ['SSBID']);
// divide id column by 1000 to avoid weird error on export
grid = grid.map(function(ft){return ft.set('SSBID', ee.Number(ft.get('SSBID')).toFloat().divide(1000))})
Map.addLayer(grid, {}, 'grid',0)

// Import FKB buildings as image collection
var buildings = ee.ImageCollection('users/zandersamuel/NINA/Raster/Norway_FKB_bygning').mean();
// Create a building mask image
buildings = ee.Image(1).where(buildings.gte(0), 0);
Map.addLayer(buildings, {min:0, max:1},'buildings',0);

// Import NiN reference polygons for våtmark & andre åpne
var nin = ee.FeatureCollection('projects/nina/Ecological_condition/nin_cleaned');
Map.addLayer(nin.style({fillColor: '#6fdbde', color: '#6fdbde'}), {}, 'nin all', 0);
// Filter for reference polygons with good condition
nin = nin.filter(ee.Filter.eq('tilstnd', 'God'));

// Separate NiN polygons into the two ecosystem types
var vaatmark_nin = nin.filter(ee.Filter.eq('hvdksys', 'V�tmark'));
vaatmark_nin = ee.Image(0).paint(vaatmark_nin, 1);
Map.addLayer(vaatmark_nin.selfMask().focal_mode(), {palette:['#6fdbde']}, 'vaatmark_nin',0);

var aapne_nin = nin.filter(ee.Filter.inList('hvdksys', ['Semi-naturlig', 'Naturlig �pne']));
aapne_nin = ee.Image(0).paint(aapne_nin, 1);
Map.addLayer(aapne_nin.selfMask().focal_mode(), {palette:['#6fdbde']}, 'aapne_nin',0);

// Import LiDAR data
var dtm_col = ee.ImageCollection("users/vegar/dtm1/dtmcoll");
var dsm_col = ee.ImageCollection("users/vegar/dom1/domcoll");
var dsm = ee.Image(dsm_col.mean()).rename('DSM');
var dtm = ee.Image(dtm_col.mean()).rename('DTM');

// Get a lidar coverage mask
var lidarCover = dtm.gt(0).selfMask()
Map.addLayer(lidarCover, {palette:['red']}, 'lidarCover', 0)

// Calculate the canopy height model
var chm = dsm.subtract(dtm); // Canopy height model is DSM subtract DTM
chm = chm.where(chm.lt(0), 0);
chm = chm.where(buildings.eq(0), 0) // mask buildings
Map.addLayer(chm, {min:0, max:20, palette:virdis}, 'chm 1m', 0);

// Import AR50 land cover to identify all land
var ar50_col = ee.ImageCollection('users/zandersamuel/NINA/Raster/AR50');
var ar50 = ar50_col.mean();
var land = ar50.neq(81).and(ar50.neq(82)).rename('land');
Map.addLayer(land.selfMask(), {}, 'land', 0)

// Import AR5 raster data for våtmark & andre åpne & skog
var ar5_col = ee.ImageCollection('users/zandersamuel/NINA/Raster/Norway_FKB_AR5_2022').select('artyp');
var ar5 = ar5_col.mosaic();

// Define AR5 areas that are mapped
var ar5Cover = ar5.neq(99).and(ar5.neq(82)).and(ar5.neq(255)).selfMask();
Map.addLayer(ar5Cover, {palette:['red']}, 'ar5Cover', 0)

// Define AR5 wetland (myr)
var vaatmark_ar5 = ar5.eq(60).updateMask(ar5Cover);
Map.addLayer(vaatmark_ar5.selfMask().focal_mode(), {palette:['#f9837b']}, 'vaatmark_ar5',0);

// Define AR5 open ecosystems (åpent fastmark + innmarksbeite)
var aapne_ar5 = ar5.eq(50).or(ar5.eq(23)).updateMask(ar5Cover);
Map.addLayer(aapne_ar5.selfMask().focal_mode(), {palette:['#f9837b']}, 'aapne_ar5', 0)

// Define AR5 forest
var skog = ar5.eq(30).updateMask(ar5Cover);
Map.addLayer(skog.selfMask().focal_mode(), {palette:['#7f7f7f']}, 'skog', 0)

// Import forest clear-cut data
var disturbance = ee.ImageCollection("users/corneliussenf/european_disturbance_maps").mosaic()
disturbance = disturbance.updateMask(disturbance.gt(1986)).gt(0);
Map.addLayer(disturbance.selfMask(), {palette:['#e6e304']}, 'disturbance',0)

// Only include non clear-cut forests in the definition of AR5 forest
skog = skog.where(disturbance.eq(1), 0)
Map.addLayer(skog.selfMask().focal_mode(), {palette:['#e6e304']}, 'skog', 0)

// Add the regions to the map for visualization
Map.addLayer(regions.style({fillColor: '#00000000'}), {}, 'regions', 0)

/*
  // 2. Export data coverages ///////////////////////////////////////////////////////////////////////////////
*/

// Make image stack of different data masks
var exportAreas = lidarCover.rename('lidarCover')
  .addBands(vaatmark_ar5.rename('vaatmark_ar5'))
  .addBands(aapne_ar5.rename('aapne_ar5'))
  .addBands(vaatmark_nin.rename('vaatmark_nin'))
  .addBands(aapne_nin.rename('aapne_nin'))
  .addBands(skog.rename('skog'))
  .addBands(land.rename('land'));
exportAreas = exportAreas.updateMask(land);
// Multiply by pixel area
var areaImage = ee.Image.pixelArea().multiply(exportAreas)

// Get areas for each SSB 10km grid cell
var areas = areaImage.reproject(ee.Projection('EPSG:25832').atScale(10)).reduceRegions({
    reducer: ee.Reducer.sum(),
    collection: grid, //.filterBounds(geometry),
    scale: 10
    }); 
print(areas.limit(10), 'grid coverage areas')

// Export to drive
Export.table.toDrive({
  collection: areas,
  description: 'area_cover_grid',
  fileFormat: 'CSV'
})

/*
  // Extract vegetation height data ///////////////////////////////////////////////////////////////////////////////
*/

// Export sample of wetland veg heights in reference, population and forest areas
var vaatmarkExport = regions
  //.filterBounds(geometry2) // can uncomment for debugging
  .map(function(g){
  var feats = extractData(g.geometry(), chm.updateMask(vaatmark_nin), chm.updateMask(vaatmark_ar5))
  feats = feats.map(function(f){return f.set('id', g.get('id'))})
  return feats
}).flatten()
print(vaatmarkExport.limit(10))
Export.table.toDrive({
  collection: vaatmarkExport,
  description: 'vaatmark_veg_heights',
  fileFormat: 'CSV'
})

// Export sample of open ecosystem veg heights in reference, population and forest areas
var aapneExport = regions
  //.filterBounds(geometry2)
  .map(function(g){
  var feats = extractData(g.geometry(), chm.updateMask(aapne_nin), chm.updateMask(aapne_ar5))
  feats = feats.map(function(f){return f.set('id', g.get('id'))})
  return feats
}).flatten()
print(aapneExport.limit(10))
Export.table.toDrive({
  collection: aapneExport,
  description: 'aapne_veg_heights',
  fileFormat: 'CSV'
})

// Function to extract sample of vegetation heights
function extractData(aoi, refImg, popImg){
  refImg = refImg.rename('reference');
  popImg = popImg.rename('population');
  var skogH = chm.updateMask(skog).rename('skog');
  
  var sample_ref = refImg.addBands(refImg.gte(0).rename('strat')).stratifiedSample({
    region:aoi,
    classBand: 'strat',
    scale:5,
    numPoints:1000,
    seed:123
  }).select(['reference'], ['height']).map(function(ft){ return ft.set('type', 'reference')})
  
  var sample_pop = popImg.addBands(popImg.gte(0).rename('strat')).stratifiedSample({
    region:aoi,
    classBand: 'strat',
    scale:5,
    numPoints:1000,
    seed:123
  }).select(['population'], ['height']).map(function(ft){ return ft.set('type', 'population')})
  
  var sample_skog = skogH.addBands(skogH.gte(0).rename('strat')).stratifiedSample({
    region:aoi,
    classBand: 'strat',
    scale:5,
    numPoints:1000,
    seed:123
  }).select(['skog'], ['height']).map(function(ft){ return ft.set('type', 'skog')})
  
  return sample_ref.merge(sample_pop).merge(sample_skog)
}