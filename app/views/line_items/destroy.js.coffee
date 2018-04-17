cart = document.getElementById("cart")
cart.innerHTML = "<%= j render_if(@cart.line_items.any?, @cart) %>"
