push = require 'push'


Class = require 'class'


require 'Paddle'


require 'Ball'


WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720


VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243


PADDLE_SPEED = 200

function love.load()

    love.graphics.setDefaultFilter('nearest', 'nearest')

    math.randomseed(os.time())

    smallFont = love.graphics.newFont('font.ttf', 8)
    largeFont = love.graphics.newFont('font.ttf', 16)
    scoreFont = love.graphics.newFont('font.ttf', 32)
    love.graphics.setFont(smallFont)


    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })


    sounds = {
        ['paddle_hit'] = love.audio.newSource('paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('score.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('wall_hit.wav', 'static')
    }


    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)


    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    -- initialize score variables
    player1Score = 0
    player2Score = 0


    servingPlayer = 1

    winningPlayer = 0

    gameState = 'start'

    -- a table we'll use to keep track of which keys have been pressed this
    -- frame, to get around the fact that LÖVE's default callback won't let us
    -- test for input from within other functions
    love.keyboard.keysPressed = {}
end

function Paddle:updateAI(dt, dy, bdy)
    if self.dy < 0 then
        self.y = math.max(0, by + bdy * dt)
    else
        self.y = math.min(VIRTUAL_HEIGHT - self.height, dy + bdy * dt)
    end
end

function love.resize(w, h)
    push:resize(w, h)
end


function love.update(dt)
    if gameState == 'start' then

        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
            gameState = 'serve'
        end
    elseif gameState == 'serve' then

        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
            gameState = 'play'


            ball.dy = math.random(-50, 50)
            if servingPlayer == 1 then
                ball.dx = math.random(140, 200)
            else
                ball.dx = -math.random(140, 200)
            end
        end
    elseif gameState == 'play' then

        if ball:collides(player1) then
            ball.dx = -ball.dx * 1.03
            ball.x = player1.x + 5

            if ball.y < player1.y + player1.height / 2 then
                ball.dy = -math.random(50, 100) * (player1.y +
                    (player1.height / 2)) / ball.y
            else
                ball.dy = math.random(50, 100) *
                    (player1.y + player1.height) / ball.y
            end

            sounds['paddle_hit']:play()
        end
        if ball:collides(player2) then
            ball.dx = -ball.dx * 1.03
            ball.x = player2.x - 4

            if ball.y < player2.y + player2.height / 2 then
                ball.dy = -math.random(50, 100) * (player2.y +
                    (player2.height / 2)) / ball.y
            else
                ball.dy = math.random(50, 100) *
                    (player2.y + player2.height) / ball.y
            end

            sounds['paddle_hit']:play()
        end

        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy
            sounds['wall_hit']:play()
        end


        if ball.y >= VIRTUAL_HEIGHT - 4 then
            ball.y = VIRTUAL_HEIGHT - 4
            ball.dy = -ball.dy
            sounds['wall_hit']:play()
        end


        if ball.x < 0 then
            servingPlayer = 1
            player2Score = player2Score + 1
            sounds['score']:play()


            if player2Score == 10 then
                winningPlayer = 2
                gameState = 'done'
            else
                gameState = 'serve'
                ball:reset()
            end
        end

        if ball.x > VIRTUAL_WIDTH then
            servingPlayer = 2
            player1Score = player1Score + 1
            sounds['score']:play()

            if player1Score == 10 then
                winningPlayer = 1
                gameState = 'done'
            else
                gameState = 'serve'
                ball:reset()
            end
        end

    elseif gameState == 'done' then

        if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
            gameState = 'serve'

            ball:reset()

            player1Score = 0
            player2Score = 0

            if winningPlayer == 1 then
                servingPlayer = 2
            else
                servingPlayer = 1
            end
        end
    end

    if love.keyboard.isDown('w') then
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end

    player1:update(dt)
    player2:updateAI(dt, ball.y, ball.dy)


    ball:update(dt)


    love.keyboard.keysPressed = {}
end

function love.keypressed(key)
    if key == 'escape' then

        love.event.quit()
    end

    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.draw()

    push:apply('start')

    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 1)


    if gameState == 'start' then

        love.graphics.setFont(smallFont)
        love.graphics.printf('Welcome to Pong!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to begin!', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'serve' then

        love.graphics.setFont(smallFont)
        love.graphics.printf('Player ' .. tostring(servingPlayer) .. "'s serve!",
            0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to serve!', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'play' then

    elseif gameState == 'done' then

        love.graphics.setFont(largeFont)
        love.graphics.printf('Player ' .. tostring(winningPlayer) .. ' wins!',
            0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter to restart!', 0, 30, VIRTUAL_WIDTH, 'center')
    end

    displayScore()

    player1:render()
    player2:render()
    ball:render()

    displayFPS()


    push:apply('end')
end


function displayScore()
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50,
        VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30,
        VIRTUAL_HEIGHT / 3)
end


function displayFPS()

    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end