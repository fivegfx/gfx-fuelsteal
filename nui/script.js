window.addEventListener("message", function (e) { 
    const data = e.data
    switch (data.type) {
        case "display":
            Display(data)
            break;
        case "update":
            UpdateFuelLevel(data)
            break;
        default:
            break;
    }
})

Display = (data) => {
    if (data.bool) {
        UpdateFuelLevel(data)
        $(".gfx-stealfuel-contain").fadeIn(250)
    } else {
        $(".gfx-stealfuel-contain").fadeOut(250)
    }
}

UpdateFuelLevel = (data) => {
    data.value = Math.ceil(data.value)
    $(".fuel-header > p > span").html(data.value)
    $(".fuel-proggres").css("height", data.value + "%")
}