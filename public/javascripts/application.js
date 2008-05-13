window.setTimeout('showHelp()',5000);
function showHelp() {
  if (document.getElementById("help")) {
    document.getElementById("help").style.display = "block";
  }
}
window.setTimeout('hideHelp()',50000);
function hideHelp() {
  if (document.getElementById("help")) {
    document.getElementById("help").style.display = "none";
  }
}
window.clearTimeout();
