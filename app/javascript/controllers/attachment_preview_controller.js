import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["attachmentInput", "imgContainer"];
  static values = { width: Number, height: Number };
  static classes = ["wrapper"];

  connect() {
    this.setPreviewImages();
  }

  setPreviewImages() {
    let newElements = [];
    Array.from(this.attachmentInputTarget.files).forEach((file) => {
      if (file["type"].startsWith("image/")) {
        let img = document.createElement("img");
        img.src = URL.createObjectURL(file);
        img.style.maxWidth = this.widthValue + "px";
        img.style.maxHeight = this.heightValue + "px";
        if (this.wrapperClass) {
          let wrapper = document.createElement("div");
          wrapper.classList.add(...this.wrapperClasses);
          wrapper.appendChild(img);
          newElements.push(wrapper);
        } else {
          newElements.push(img);
        }
      }
    });
    this.imgContainerTarget.replaceChildren(...newElements);
  }
}
