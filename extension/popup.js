"use strict";

import * as Starpub from "./starpub.min.js";

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
          let titleInp = document.getElementById("title");
          let descInp = document.getElementById("description");

          console.log("signature verified: ", v, t);
          titleInp.value = t.title;
        });
      });
    });
  });
});
