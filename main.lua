VIRTUAL_WIDTH = 374
VIRTUAL_HEIGHT = 206
WINDOW_WIDTH = 1190
WINDOW_HEIGHT = 655

PADDLE_WIDTH = 8
PADDLE_HEIGHT = 32
PADDLE_SPEED = 140

BALL_SIZE = 8

LARGE_FONT = love.graphics.newFont(32)
SMALL_FONT = love.graphics.newFont(16)

push = require 'push'

player1 = {
    x = 10 , y = 10 , score = 0
}

player2 = {
    x = VIRTUAL_WIDTH - 10 - PADDLE_WIDTH ,y =  VIRTUAL_HEIGHT - 10 - PADDLE_HEIGHT,
    score = 0
}

ball = {
    x = VIRTUAL_WIDTH / 2 - BALL_SIZE / 2 , y = VIRTUAL_HEIGHT / 2 - BALL_SIZE /2,
    dx = 0 , dy = 0
}

gameState = 'title'

function love.load()
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest', 'nearest')
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT)

    ResetBall()
end

function love.update(dt)
    if love.keyboard.isDown('w') then
        player1.y = player1.y - PADDLE_SPEED * dt
    elseif love.keyboard.isDown('s') then
        player1.y = player1.y + PADDLE_SPEED * dt
    end

    if love.keyboard.isDown('up') then
        player2.y = player2.y - PADDLE_SPEED * dt
    elseif love.keyboard.isDown('down') then
        player2.y = player2.y + PADDLE_SPEED * dt
    end

    if gameState == 'play' then
         ball.x = ball.x + ball.dx * dt
         ball.y = ball.y + ball.dy * dt

         if ball.x <= 0 then
            player2.score = player2.score + 1
            gameState = 'serve'
            ResetBall()
            if player2.score == 10 then 
                gameState = 'win'
                return 0
            end
         elseif ball.x >= VIRTUAL_WIDTH - BALL_SIZE then
            player1.score = player1.score + 1
            gameState = 'serve'
            ResetBall()
            if player1.score == 10 then 
                gameState = 'win'
                return 1
            end
         end

        if ball.y <= 0 then
            ball.dy = - ball.dy
        elseif ball.y >= VIRTUAL_HEIGHT - BALL_SIZE then
            ball.dy = - ball.dy
        end

        if collides(player1, ball) then
            ball.dx = - ball.dx
            ball.x = player1.x + PADDLE_WIDTH
        elseif collides(player2, ball) then
            ball.dx = - ball.dx
            ball.x = player2.x - BALL_SIZE
        end
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    if key == 'enter' or key == 'return'  then
        if gameState == 'title' then
            gameState = 'serve'
        elseif gameState == 'serve' then
            gameState = 'play'  
        end
        if gameState == 'win' then
            gameState = 'title'
        end 
    end 
    
end

function love.draw()
    push:start()
    love.graphics.clear(65/255 , 95/255, 100/255 , 255/255)

    if gameState == 'title' then
        ResetScores()
        love.graphics.setFont(LARGE_FONT)
        love.graphics.printf('Just a stupid game',0 , 10, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(SMALL_FONT)
        love.graphics.printf('Press Enter', 0, VIRTUAL_HEIGHT - 32 , VIRTUAL_WIDTH , 'center')
    end

    if gameState == 'serve' then 
        love.graphics.setFont(SMALL_FONT)
        love.graphics.printf('Press enter to serve!',0 , 10, VIRTUAL_WIDTH, 'center')
    end

    love.graphics.rectangle('fill',player1.x ,player1.y ,PADDLE_WIDTH, PADDLE_HEIGHT)
    love.graphics.rectangle('fill',player2.x ,player2.y ,PADDLE_WIDTH, PADDLE_HEIGHT)
    love.graphics.rectangle('fill',ball.x ,ball.y ,BALL_SIZE, BALL_SIZE)
    
    love.graphics.setFont(LARGE_FONT)
    love.graphics.print(player1.score, VIRTUAL_WIDTH / 2 - 46 , VIRTUAL_HEIGHT / 2 - 16)
    love.graphics.print(player2.score, VIRTUAL_WIDTH / 2 + 26 , VIRTUAL_HEIGHT / 2 - 16)
    
    if gameState == 'win' then
       love.graphics.setFont(LARGE_FONT)
       love.graphics.printf('Game over',0 ,10 , VIRTUAL_WIDTH, 'center')
       love.graphics.setFont(SMALL_FONT)
       love.graphics.printf('Press Enter', 0, VIRTUAL_HEIGHT - 32 , VIRTUAL_WIDTH , 'center')
    end

    
    push:finish()
end

function collides(p, b)
    return not (p.x > b.x + BALL_SIZE or p.y > b.y - BALL_SIZE or p.x + PADDLE_WIDTH < b.x  or p.y + PADDLE_HEIGHT < b.y)
end

function ResetBall()
    ball.x = VIRTUAL_WIDTH / 2 - BALL_SIZE / 2  
    ball.y = VIRTUAL_HEIGHT / 2 - BALL_SIZE /2
    
    ball.dx = 60 + math.random(60)
    if math.random(2) == 1 then
        ball.dx = - ball.dx
    end
    ball.dy = 30 + math.random(60)
    if math.random(2) == 1 then
        ball.dy = - ball.dy
    end
end

function ResetScores()
    player1.score = 0
    player2.score = 0
end 
