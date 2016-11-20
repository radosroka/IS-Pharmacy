function searchItems() {
	var text = document.getElementById('searchBoxText').value;
	var location = "lekaren/find-items/?searchedText=";
	window.location.pathname = location + text;
}

document.getElementById("searchBoxText")
    .addEventListener("keyup", function(event) {
    event.preventDefault();
    if (event.keyCode == 13) {
        document.getElementById("searchButton").click();
    }
});