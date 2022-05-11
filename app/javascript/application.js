// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
// import "@hotwired/turbo-rails"

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import "controllers"
import * as ActiveStorage from "@rails/activestorage"
import "channels"




Rails.start()
Turbolinks.start()
ActiveStorage.start()

window.initMap = () => {
    console.log('initMap was called');
    const event = new Event("MapLoaded")
    event.initEvent("map-loaded", true, true);
    window.dispatchEvent(event)
}
