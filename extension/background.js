import * as Starpub from "./starpub.js";

document.addEventListener("DOMContentLoaded", function () {
  let starKey = new Starpub();

  browser.browserAction.onClicked.addListener(function () {
    let maybeKey = starKey.getKey();
    maybeKey.then((_) => {
      let tab = browser.tabs.query({ active: true, currentWindow: true });
      tab.then(function (a) {
        const t = a[0];
        const st = starKey.sign({
          url: t.url,
          title: t.title,
        });
        st.then((p) => {
          const vfy = Coze.Verify(p, starKey.pubKey);
          vfy.then((v) => {
            console.log("signature verified: ", v);
            console.log(t.url, t.title);
            console.log(starKey.pubKey);
          });
        });
      });
    });
  });
});
