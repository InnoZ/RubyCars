var allFunctions = function() {
////////////////////////////////////////////////////////////
// all the functions to be loaded after document is ready //
////////////////////////////////////////////////////////////

  jQuery('.dropdown-toggle').dropdown(); // bootstrap dropdown not working on production otherwise

  var responsiveMapSize = function() {
    var headerOffset = jQuery('header:visible').outerHeight();
    var innerHeight = jQuery(window).height() - jQuery('.navbar').outerHeight() - headerOffset;
    jQuery('#map').height(innerHeight);
  };

  var switchBaseLayer = function(theme) {
    if (typeof baselayer != 'undefined') { map.removeLayer(baselayer) };
    if ( theme == 'dark' ) { url = 'http://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png' };
    if ( theme == 'light' ) { url = 'http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png' }
    baselayer = L.tileLayer(url, {
      attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
    });
    map.addLayer(baselayer);
  };

  map = L.map('map');
  map.options.minZoom = 2;

  var loadingText = function() {
    jQuery('#map').append("<div class='loading-text'><span>loading...</span></div>");
  };

  jQuery(".provider-button-container").mouseenter(function(){ map.dragging.disable(); map.scrollWheelZoom.disable(); })
                                      .mouseleave(function(){ map.dragging.enable(); map.scrollWheelZoom.enable(); })

  if (document.cookie.indexOf('map_theme=light') != -1) {
    switchBaseLayer('light');
    jQuery('.map-theme-switcher').hide().not('#light-map-theme').show();
  } else {
    switchBaseLayer('dark');
    jQuery('.map-theme-switcher').hide().not('#dark-map-theme').show();
  };

  jQuery(window).resize(function(){
    responsiveMapSize();
  }).resize();

  if (document.cookie.indexOf('map_theme=light') != -1) {
    markerColor = 'blue';
  } else {
    markerColor = 'yellow';
  };

  if ( MarkersToShow == 'regions' ) {
    jQuery('#map').append("<div class='map-overlay centered-map-overlay welcome-text'> \
                            <div> \
                              Discover station-based carsharing by selecting a region on the map or via dropdown... \
                            </div> \
                          </div>");

    var onEachFeature = function (feature, layer) {
      function showProviderInfo(e) { jQuery('#map').append("<div class='map-overlay centered-map-overlay hover-info'> \
                                                              <div><table> \
                                                                <tr><td><b>Region:</b></td><td><b>" + feature.properties.region + "</b></td></tr> \
                                                                <tr><td><b>Stations:</b></td><td><b>" + feature.properties.stations + "</b></td></tr> \
                                                              </table></div> \
                                                            </div>");
      };
      function removeProviderInfo(e) { jQuery('.hover-info').remove() };
      layer.on('mouseover', showProviderInfo);
      layer.on('mouseout', removeProviderInfo);
      layer.on('click', function(e) {
        loadingText();
        window.location.href = "/stations?region=" + feature.properties.region;
      })
    };

    providers = L.geoJson(regionsGeojson, {
      onEachFeature: onEachFeature,
      pointToLayer: function (feature, latlng) {
        var radius = Math.max(Math.min(feature.properties.stations / 30, 50), 5);
        return L.circleMarker(latlng, {radius: radius, color: markerColor, fillOpacity: 0.4, stroke: false});
      }
    });
    map.addLayer(providers);
    map.setView([10, -10], 2);
    map.options.maxZoom = 7;
  };

  if ( MarkersToShow == 'stations' ) {
    var onEachFeature = function(feature, layer) {
      function showStationInfo(e) { jQuery('#map').append("<div class='map-overlay centered-map-overlay hover-info'> \
                                                              <div><table> \
                                                                <tr><td><b>Cars:</b></td><td><b>" + feature.properties.cars + "</b></td></tr> \
                                                                <tr><td>Provider:</td><td>" + feature.properties.provider_name + "</td></tr> \
                                                                <tr><td>Last update:</td><td>" + feature.properties.last_update + "</td></tr> \
                                                              </table></div> \
                                                            </div>");

      };
      function removeStationInfo(e) { jQuery('.hover-info').remove() };
      layer.on('mouseover', showStationInfo);
      layer.on('mouseout', removeStationInfo);
    };

    var markers = L.markerClusterGroup({
      disableClusteringAtZoom: 10,
      maxClusterRadius: 50
    });

   var getProvidersInCluster = function(cluster) {
    var unique = function(array) {
      return array.filter(function(v, i) {
        return array.indexOf(v) === i
      })
    }
    var children = cluster.getAllChildMarkers();
    var providers = unique(jQuery.map(children, function(child) { return ' ' + child.feature.properties.provider_name }))
    if ( providers.length < 4 ) {
      return providers;
    } else {
      return providers.slice(0,3) + ' and more...'
    };
   };

    markers.on('clustermouseover', function (a) {
      jQuery('#map').append("<div class='map-overlay centered-map-overlay hover-info'> \
                                <div><table> \
                                  <tr><td><b>Providers:</b></td><td><b>" + getProvidersInCluster(a.layer) + "</b></td></tr> \
                                  <tr><td><b>Stations:</b></td><td><b>" + a.layer.getChildCount() + "</b></td></tr> \
                                </table></div> \
                              </div>");
    });

    markers.on('clustermouseout', function (a) {
      jQuery('.hover-info').remove()
    });

    var stations = L.geoJson(stationsGeojson, {
      onEachFeature: onEachFeature,
      pointToLayer: function (feature, latlng) {
        var radius = 4 + feature.properties.cars;
        if (feature.properties.cars == 0) {
          return L.circleMarker(latlng, {radius: radius, fillOpacity: 0, color: markerColor, stroke: true});
        } else {
          return L.circleMarker(latlng, {radius: radius, fillOpacity: 0.6, color: markerColor, stroke: false});
        };
      }
    });

    markers.addLayer(stations);
    map.addLayer(markers);
    map.fitBounds(markers.getBounds());
  };

  jQuery(".map-theme-switcher").click(function() {
    if (this.id == 'light-map-theme') {
      document.cookie="map_theme=light";
      switchBaseLayer('light');
      if (typeof stations != 'undefined') { stations.setStyle({color: 'blue'}) };
      if (typeof providers != 'undefined') { providers.setStyle({color: 'blue'}) };
      jQuery('#light-map-theme').hide();
      jQuery('#dark-map-theme').show();
    } else {
      document.cookie="map_theme=dark";
      switchBaseLayer('dark');
      if (typeof stations != 'undefined') { stations.setStyle({color: 'yellow'}) };
      if (typeof providers != 'undefined') { providers.setStyle({color: 'yellow'}) };
      jQuery('#dark-map-theme').hide();
      jQuery('#light-map-theme').show();
    };
  });

  jQuery(".provider-button").click(function() { loadingText(); });
  jQuery(".region-dropdown-menu").click(function() { loadingText(); });

};

jQuery(document).ready(allFunctions);
jQuery(document).on('page:load', allFunctions); // needed due to turobolinks gem. see: http://stackoverflow.com/questions/17600093/rails-javascript-not-loading-after-clicking-through-link-to-helper
