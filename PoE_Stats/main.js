const https = require("https");

https.get('https://web.poe.garena.tw/api/trade/data/stats', (res) => {
    let rowdata = "";
    res.on('data', (chunk) => {
        rowdata += chunk;
    });
    res.on('end', () => {
        let json_data = JSON.parse(rowdata);
        json_data.result.forEach(Label => {
            //console.log(Label);
            if (Label.label == "隨機屬性") {
                Label.entries.forEach(stats => {
                    console.log(stats.text);
                })
            }
        });
    });
});