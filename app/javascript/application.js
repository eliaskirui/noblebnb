// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.


/* eslint no-console:0 */

// Rails functionality
// import Rails from "@rails/ujs"
// import { Turbo } from "@hotwired/turbo-rails"
//
// // Make accessible for Electron and Mobile adapters
// window.Rails = Rails
// window.Turbo = Turbo
//
// require("@rails/activestorage").start()
// import "@rails/actiontext"
//
// // ActionCable Channels
// import "./channels"
//
// // Stimulus controllers
// import "./controllers"
//
// // Jumpstart Pro & other Functionality
// import "./src/**/*"
// require("local-time").start()
//
// // Start Rails UJS
// Rails.start()


import "@hotwired/turbo-rails"
import "./controllers"

window.initMap = () => {
    console.log('initMap was called');
    const event = new Event("MapLoaded")
    event.initEvent("map-loaded", true,  true);
    window.dispatchEvent(event)
}





















// import Rails from "@rails/ujs"
// import Turbolinks from "turbolinks"
// import * as ActiveStorage from "@rails/activestorage"
// import "channels"
// import "controllers"
//
// Rails.start()
// Turbolinks.start()
// ActiveStorage.start()
//
// window.initMap = () => {
//     console.log('initMap was called');
//     const event = new Event("MapLoaded")
//     event.initEvent("map-loaded", true, true);
//     window.dispatchEvent(event)
// }