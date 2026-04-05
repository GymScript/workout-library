// Progressive enhancement — clipboard copy for the workout script block.
(function () {
  var btn = document.querySelector("[data-copy-script]");
  var pre = document.querySelector("[data-workout-script]");

  if (!btn || !pre || !navigator.clipboard) return;

  btn.addEventListener("click", function () {
    navigator.clipboard.writeText(pre.textContent).then(function () {
      var original = btn.textContent;
      btn.textContent = "Copied!";
      btn.setAttribute("aria-label", "Script copied to clipboard");
      setTimeout(function () {
        btn.textContent = original;
        btn.setAttribute("aria-label", "Copy workout script to clipboard");
      }, 2000);
    });
  });
}());
