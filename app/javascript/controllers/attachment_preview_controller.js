import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["attachmentInput", "imgContainer"];
  static values = { width: Number, height: Number };
  static classes = ["wrapper"];

  setPreviewImages() {
    let wrappers = [];
    console.log(this.wrapperClasses);
    Array.from(this.attachmentInputTarget.files).forEach((file) => {
      let wrapper = document.createElement("div");
      let img = document.createElement("img");
      img.src = URL.createObjectURL(file);
      img.style.maxWidth = this.widthValue + "px";
      img.style.maxHeight = this.heightValue + "px";
      wrapper.appendChild(img);
      wrapper.classList.add(...this.wrapperClasses);
      wrappers.push(wrapper);
    });
    this.imgContainerTarget.replaceChildren(...wrappers);

    this.imgContainerTarget.appendChild;
  }
}
