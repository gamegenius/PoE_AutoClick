const https = require("https");
const fs = require("fs");

https.get('https://web.poe.garena.tw/api/trade/data/stats', (res) => {
    let rowdata = "";
    res.on('data', (chunk) => {
        rowdata += chunk;
    });
    res.on('end', () => {
        let json_data = JSON.parse(rowdata);
        json_data.result.forEach((Label) => {
            //console.log(Label);
            if (Label.label == "隨機屬性") {
                let data = "";
                Label.entries.forEach((stats, index) => {
                    if (index == (Label.entries.length - 1)) {
                        data += stats.text + "\n";
                        fs.writeFile("stats.txt", data, (err) => {
                            if (err) throw err;
                            console.log('The file has been saved!');
                        });
                    } else {
                        data += stats.text + "\n";
                    }
                })
            }
        });
    });
});