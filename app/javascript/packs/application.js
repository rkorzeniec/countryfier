import $ from 'jquery';
import Rails from 'rails-ujs';
import Turbolinks  from 'turbolinks';

Rails.start();
Turbolinks.start();
window.$ = $;
