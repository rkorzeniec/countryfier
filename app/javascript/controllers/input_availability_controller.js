import { Controller } from 'stimulus'
import { getCSRFToken } from '../src/utils/csrf_token'

export default class extends Controller {
  static targets = ['input']

  check() {
    this.checkAvailability()
  }

  checkAvailability() {
    const url = this.getUrl()
    const options = {
      method: 'GET',
      credentials: 'same-origin',
      headers: { 'X-CSRF-Token': getCSRFToken() }
    }

    fetch(url, options)
      .then(response => response.json())
      .then(data => {
        if (data.availability || this.matchingProfileName()) {
          this.markTargetAsAvailable()
        } else if (this.inputTarget.value) {
          this.markTargetAsAvailable()
        } else {
          this.markTargetAsUnavailable()
        }
      })
  }

  getUrl() {
    return this.data.get('url') + '?' +
      this.data.get('param') + '=' + encodeURIComponent(this.inputTarget.value)
  }

  markTargetAsAvailable() {
    this.inputTarget.classList.remove('is-invalid')
    this.inputTarget.classList.add('is-valid')
  }

  markTargetAsUnavailable() {
    this.inputTarget.classList.remove('is-valid')
    this.inputTarget.classList.add('is-invalid')
  }

  matchingProfileName() {
    return this.inputTarget.value === this.data.get('current-profile-name')
  }
}
