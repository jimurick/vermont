/*
window.onload = function() {
  alert("hi")
}
*/

// Image preview when hovering over link is based on this:
// https://nam10.safelinks.protection.outlook.com/?url=https%3A%2F%2Fstackoverflow.com%2Fa%2F64515306&data=05%7C02%7Curickj%40chop.edu%7C42c27c534c834e3bc94708dcf67a9edf%7Ca611241607b041a59bb1d146b575c975%7C0%7C0%7C638656253722230647%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C0%7C%7C%7C&sdata=%2F9WklsCLRrioKYyLBsYRJQt6yn6YIqHi8yCIV%2FiyAbE%3D&reserved=0

let attached = false;
let imageContainer = null;

const followMouse = (event) => {
  imageContainer.style.left = event.x + "px";
  imageContainer.style.top = event.y + "px";
}

function showImage(id) {
  if (!attached) {
    attached = true;
    imageContainer = document.querySelector("#" + id);
    imageContainer.style.display = "block";
    document.addEventListener("pointermove", followMouse);
  }
}

function hideImage() {
  attached = false;
  if (imageContainer != null) {
    imageContainer.style.display = "";
    document.removeEventListener("pointermove", followMouse);
    imageContainer = null;
  }
}
