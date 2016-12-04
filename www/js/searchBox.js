function searchItems() {


	  var text = document.getElementById('searchBoxText').value;
	  var protocol = window.location.protocol;
	  var hostname = window.location.hostname;
	  var url = protocol + '//' + hostname + "/lekaren/find-items?searchedText=" + text;
	  window.location.href = url;
}

document.getElementById("searchBoxText")
    .addEventListener("keyup", function(event) {
    event.preventDefault();
    if (event.keyCode == 13) {
        document.getElementById("searchButton").click();
    }
});