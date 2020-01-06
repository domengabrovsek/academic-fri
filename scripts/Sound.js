let hitWall = new Audio('../sounds/wallHit.mp3');
hitWall.load();

let endGameSound = new Audio('../sounds/applause.mp3');
endGameSound.load();

let backgroundMusic = new Audio('../sounds/background.mp3');
backgroundMusic.load();


function playEndGameMusic() {
    backgroundMusic.pause();
    backgroundMusic.currentTime = 0;
    endGameSound.play();
}

function playWallHitMusic() {
    // TODO
    backgroundMusic.pause();
    backgroundMusic.currentTime = backgroundMusic.currentTime;
    hitWall.play();
    backgroundMusic.play();
}

function playBackgroundMusic() {
    backgroundMusic.play();
}