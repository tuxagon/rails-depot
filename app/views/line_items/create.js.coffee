cart = document.getElementById("cart")
cart.style.display = "block"
cart.innerHTML = "<%= j render(@cart) %>"

notice = document.getElementById("notice")
if notice
  notice.style.display = "none"
