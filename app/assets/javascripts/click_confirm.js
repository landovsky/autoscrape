function confirmClick(element, event) {
  const warning = element.data('warning')
    if (warning === undefined) {
      return
    } else {
      const response = confirm(warning)
      if (response == true) {
        return
      } else {
        event.preventDefault();
        event.stopPropagation();
      }
    } 
}

$(document).ready(function() {
  $('.confirm').click(function (event) {
    confirmClick($(this), event)
  })
})
