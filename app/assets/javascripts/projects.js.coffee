$ ->
  $(document).on 'click', 'tr[data-link]', (evt) -> 
    window.location = this.dataset.link

$ ->
  $(document).on 'click', 'header[data-link]', (evt) ->
    window.location = this.dataset.link
