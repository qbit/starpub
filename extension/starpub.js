"use strict";

import * as Coze from "./coze.min.js";

export { Starpub };

class Starpub {
  async getKey() {
    let key = await browser.storage.local.get("starKey");
    if (Object.keys(key).length < 1) {
      this.key = await Coze.NewKey("ES512");
      this.key.kid = "My StarPub Coze Key";
      await browser.storage.local.set({ starKey: this.key });
    } else {
      this.key = key.starKey;
    }
    this.thumb = await Coze.Thumbprint(this.key);
    const { d, ...pkRest } = this.key;
    this.pubKey = pkRest;
  }

  async sign(starObj) {
    return await Coze.SignCozeRaw(
      {
        pay: {
          url: starObj.url,
          title: starObj.title,
          typ: "starpub/msg/create",

          iat: Math.floor(Date.now() / 1000),
          alg: this.key.alg,
          tmb: this.key.tmb,
        },
      },
      this.key,
    );
  }

  async verify() {
    return false;
  }

  async publish() {}
}


