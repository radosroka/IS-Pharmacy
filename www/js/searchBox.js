function searchItems() {
	var text = document.getElementById('searchBoxText').value;
	var location = "lekaren/find-items/?searchedText=";
	window.location.pathname = location + text;
}