import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["attachmentInput", "imgContainer"];
  static values = { width: Number, height: Number };

  setPreviewImages() {
    let images = [];
    Array.from(this.attachmentInputTarget.files).forEach((file) => {
      let img = document.createElement("img");
      img.src = URL.createObjectURL(file);
      img.style.objectFit = "contain";
      img.width = this.widthValue;
      img.height = this.heightvalue;
      images.push(img);
      this.imgContainerTarget.appendChild(img);
    });
    this.imgContainerTarget.replaceChildren(...images);
  }
}
