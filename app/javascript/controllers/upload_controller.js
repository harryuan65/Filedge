import { Turbo } from '@hotwired/turbo-rails';
import { Controller } from '@hotwired/stimulus';
export default class extends Controller {
  static targets = ['file'];
  form;
  xhrs = [];
  get file() {
    return this.fileTarget.files[0];
  }
  connect() {
    this.form = this.element;
  }
  // Click (+ Upload File) opens the dialog for selecting a file.
  openDialog(e) {
    e.preventDefault(); // prevent form from submitting
    this.fileTarget.click();
  }

  // Uploading is triggered after a file is selected.
  upload() {
    if (!this.file) return;
    let xhrProgressId = `upload-progress-${crypto.randomUUID()}`;
    this.#createProgressBarTr(xhrProgressId);
    this.#uploadFile(xhrProgressId);
  }

  // Create a new tr to display the progress bar
  #createProgressBarTr(xhrProgressId) {
    this.#hidePlaceholderTr();

    let tr = document.querySelector('tbody tr');
    let newTr = document.createElement('tr');
    newTr.classList.add('h-10', 'border-b', 'border-gray-300');
    let newTd = document.createElement('td');
    newTd.setAttribute('colspan', 6);
    newTd.classList.add('relative', 'text-center');

    let progressText = document.createElement('span');
    progressText.classList.add('progress-text', 'text-black');

    let progressBar = document.createElement('div');
    progressBar.classList.add(
      'progress-bar',
      'absolute',
      'w-0',
      'h-full',
      'top-0',
      'bg-progress',
      '-z-[1]'
    );

    newTd.appendChild(progressText);
    newTd.appendChild(progressBar);

    newTr.id = xhrProgressId; // Can be replaced later with uploaded file partial: _user_file using turbo stream.
    newTr.appendChild(newTd);
    tr.parentElement.append(newTr);
  }

  // Update progress bar for specified xhr upload.
  #updateProgress(e, xhrId) {
    let percentage = Math.round((100.0 * e.loaded) / e.total);

    let tr = document.getElementById(xhrId);
    let td = tr.querySelector('td'); // Get first td
    let progressText = td.querySelector('.progress-text');
    let progressBar = td.querySelector('.progress-bar');
    progressBar.style.width = `${percentage}%`;

    let progress = `${e.type}: ${percentage}% (${e.loaded}/${e.total} bytes)`;
    progressText.innerHTML = progress;
    console.log(progress);
    console.log(e);
  }

  // Set up XHR and send file. Available events: [load, loadstart, loadend, error, abort]
  #uploadFile(xhrProgressId) {
    let xhr = new XMLHttpRequest();
    xhr.id = xhrProgressId;
    xhr.onload = () => {
      if (xhr.status === 200) {
        const text = xhr.responseText;
        Turbo.renderStreamMessage(text);
      } else {
        console.error('XHR request failed:', xhr.statusText);
      }
    };
    xhr.upload.onprogress = (e) => this.#updateProgress(e, xhrProgressId);
    xhr.upload.onerror = console.error;

    xhr.open(this.form.method, this.form.action);
    xhr.setRequestHeader(
      'X-CSRF-Token',
      document.querySelector("meta[name='csrf-token']").content
    );
    xhr.setRequestHeader('Accept', 'text/vnd.turbo-stream.html'); // request for turbo stream response
    var formData = new FormData();
    formData.append('progress_bar_id', xhrProgressId); // This is send to user_files#create to turbo replace the progress bar with upload _user_file
    formData.append('user_file[asset]', this.file);
    formData.append('user_file[file_size]', this.file.size);
    xhr.send(formData);
    this.xhrs.push(xhr);
  }

  // Utility Functions
  #hidePlaceholderTr() {
    let placeholder = document.getElementById('user_file_placeholder');
    if (placeholder) placeholder.style.display = 'none';
  }
}
