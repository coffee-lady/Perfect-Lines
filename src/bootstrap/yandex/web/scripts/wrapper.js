const grid_sizes = {
    x: 11,
    y: 3
};
const gap = 15;
const minSquareSize = 40;
const elementsParams = [
    [0, 0, .7],
    [0, 1, .5],
    [0, 2, .3],
    [0, 3, .5],
    [0, 4, .6],
    [0, 5, .5],
    [0, 6, 1],
    [0, 7, .7],
    [0, 8, .6],
    [0, 9, .5],
    [1, 1, .5],
    [1, 3, .5],
    [1, 4, .5],
    [1, 6, .5],
    [1, 7, .5],
    [1, 9, .5],
    [2, 3, .3],
    [2, 7, .5],
    [2, 10, .5],
];

const topSquares = [];
const bottomSquares = [];
const squareTemplate = document.getElementById('square');
const containers = document.getElementsByClassName('squares');

for (const block of containers) {
    for (let k = 0; k < elementsParams.length; k++) {
        const squareTop = squareTemplate.cloneNode();
        const squareBottom = squareTemplate.cloneNode();

        block.append(squareTop);
        block.append(squareBottom);

        topSquares.push({ node: squareTop, params: elementsParams[k] });
        bottomSquares.push({ node: squareBottom, params: elementsParams[k] });
    }
}

updateTransforms();

function updateTransforms() {
    const containerWidth = containers[0].clientWidth;
    let squareSize = (containerWidth - gap * (grid_sizes.x + 1)) / grid_sizes.x;

    squareSize = squareSize < minSquareSize ? minSquareSize : squareSize;

    for (const data of topSquares) {
        setTopSquareTransform(data, squareSize, containerWidth);
    }

    for (const data of bottomSquares) {
        setBottomSquareTransform(data, squareSize, containerWidth);
    }
}

window.addEventListener('resize', updateTransforms);
window.addEventListener('orientationchange', updateTransforms);

function setTopSquareTransform(data, squareSize, containerWidth) {
    const [i] = data.params;

    setSquareStyle(data, squareSize, containerWidth);

    data.node.style.top = i * squareSize + gap * (i + 1) + 'px';
}

function setBottomSquareTransform(data, squareSize, containerWidth) {
    const [i] = data.params;

    setSquareStyle(data, squareSize, containerWidth);

    data.node.style.bottom = i * squareSize + gap * (i + 1) + 'px';
}

function setSquareStyle(data, squareSize, containerWidth) {
    const [_, j, opacity] = data.params;

    const pos_left = j * squareSize + gap * (j + 1)

    if (pos_left + squareSize > containerWidth) {
        return;
    }

    data.node.style.display = 'block';
    data.node.style.height = squareSize + 'px';
    data.node.style.width = squareSize + 'px';
    data.node.style.left = pos_left + 'px';
    data.node.style.opacity = opacity;
    data.node.style.zIndex = 0;
}
