import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  userFileId;
  connect() {
    this.userFileId = this.element.dataset.id;
  }

  async getLink() {
    const response = await fetch(`/user_files/${this.userFileId}/share`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Accepts: 'text/plain',
        'X-CSRF-Token': document.querySelector("meta[name='csrf-token']")
          .content,
      },
    });
    const link = await response.text();
    await navigator.clipboard.writeText(link);
    alert('Share link copied!');
  }
}
