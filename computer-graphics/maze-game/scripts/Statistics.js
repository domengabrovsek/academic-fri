const apiURL = 'http://localhost:3000';
const statisticDiv = document.getElementById("statistics");
const loader = document.getElementsByClassName("loader")[0];

let getApiData = true;

let statisticData = null;


function getStatistics() {
    var request = new XMLHttpRequest();

    request.open("GET", `${apiURL}/statistic`);
    request.onreadystatechange = function () {
        if (this.readyState === XMLHttpRequest.DONE && this.status === 200) {
            console.log("Succesfully exported data");
            if (this.response) {
                let parsedJSON = JSON.parse(this.response);

                showTopFive(parsedJSON);
                statisticData = parsedJSON;
            }
        }
    }
    request.send();
}

function showStatistics(jsonData) {
    // hide loader
    loaderDisplay(false);

    if (Object.keys(jsonData).length > 0) {
        Object.keys(jsonData).forEach(key => {
            let item = jsonData[key];
            createStatisticsTable(item);
        });
    }
}

function loaderDisplay(toDisplay) {
    toDisplay ? 
    loader.style.display = "inline" :
    loader.style.display = "none";
}

function showTopFive(data) {
    // hide loader
    loader.style.display = 'none';

    if (data.length > 5) {
        createTitle("TOP 5 igralcev");

        // filter top 5 entries
        data = data.filter((entry, index) => index < 5);
        createStatisticsTable(data);
    }
}

function createTitle(text) {
    let title = document.createElement("h3");
    title.innerHTML = text;
    title.style.marginTop = "10px";

    // append title to statistic div
    statisticDiv.appendChild(title);
}


function createStatisticsTable(data) {
    let nodeTable = document.createElement("table");
    nodeTable.className = "table table-dark statisticTable";
    let tableHeader = document.createElement("thead");
    let tableHeaderRow = document.createElement("tr");

    // th 1
    let thTime = document.createElement("th");
    thTime.innerHTML = "Porabljen čas";
    thTime.scope = "col";
    tableHeaderRow.appendChild(thTime);

    // th 2
    let thPlayerName = document.createElement("th");
    thPlayerName.innerHTML = "Igralec";
    thPlayerName.scope = "col";
    tableHeaderRow.appendChild(thPlayerName);

    // th 3
    let thDate = document.createElement("th");
    thDate.innerHTML = "Datum";
    thDate.scope = "col";
    tableHeaderRow.appendChild(thDate);

    tableHeader.appendChild(tableHeaderRow);
    nodeTable.appendChild(tableHeader);

    let tableBody = document.createElement("tbody");

    data.forEach(entry => {
        let newTableNodeRow = document.createElement("tr");

        // player time
        let newTHtime = document.createElement("td");
        newTHtime.innerHTML = entry.time;
        newTableNodeRow.appendChild(newTHtime);

        let newTHplayerName = document.createElement("td");
        newTHplayerName.innerHTML = entry.playerName;
        newTableNodeRow.appendChild(newTHplayerName);

        // date
        let newTHDate = document.createElement("td");
        newTHDate.innerHTML = new Date(entry.date).toLocaleString();
        newTableNodeRow.appendChild(newTHDate);

        // add row to the table body
        tableBody.appendChild(newTableNodeRow);
    })

    nodeTable.appendChild(tableBody);
    statisticDiv.appendChild(nodeTable);
}

function loadPlayerData() {
    let textAreaPlayerName =  document.getElementById("inputPlayer").value;

    statisticDiv.innerHTML = "";
    loaderDisplay(true);

    if(statisticData.length > 0) {
        let data = statisticData.filter(entry => entry.playerName.includes(textAreaPlayerName));

        createTitle(`Statistika igralca ${textAreaPlayerName}`);
        createStatisticsTable(data);
        loaderDisplay(false);
    }
}

