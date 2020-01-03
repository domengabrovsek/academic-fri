let hitWall = new Audio('../sounds/wallHit.mp3');
hitWall.load();

let endGameSound = new Audio('../sounds/applause.mp3');
endGameSound.load();


function playEndGameMusic() {
    endGameSound.play();
}

function playWallHitMusic() {
    hitWall.play();
}