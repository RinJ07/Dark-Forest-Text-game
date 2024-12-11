.data
## TO DO

##   ---- Enemy Function   
##  ----- Win/ Lose Function	



##  ----- Player Status: Level Up Function
##  ----- Locations:
##		Blue Mushrooms Area ( Heal Player form  10 -15 %)
##		Poison Vines Area: (Deceease Player Health from 20 -40)
##		Outside of Dark Forest ( End of the Game )	
##
##
##
##
##
##
##
##
##
##
#3

## Player Info
max_hp: .word 500
weapon: .word 50

### Enemy
enemy_count: .word 0
enemy_maxhp: .word 300
enemy_hp: .word 300
enemy_weapon: .word 20




intro: .asciiz "Welcome to Dark Forest Adventure.\n (1=PLay, 2=Quit)\nEnter your Choice: " 

loading: .asciiz "\nLoading.....\n"
loading1: .asciiz "........*beep beep beep ..........."



game_intro1: .asciiz "\nYou suddenly wake up in the middle of a dark forest.\nAnd as you stood up, you found yourself in the middle of nowhere, and alone in the dark. \nYou then found yourself looking around you, and realized, that this dark forest is not a safe place to be in. \n"

player_name: .asciiz "\nWhat's your name?\n Enter you name:"

game_desc1: .asciiz "\nYou are in the middle of the Dark Forest\n"
player_msm1: .asciiz "\nI have to get out of this dangerous haunted forest immediately!\n"
game_desc2: .asciiz "\nThere is nothing here...\nWhat will you do?\n"
end_game_msm: .asciiz "\n At that moment I finally see the end of the Forest. \nI can get out now... \n END OF THE GAME.."
back_msm: .asciiz "\n1 == Back\nEnter your choice: "
heal_msm: .asciiz "\nNotice: HP has recover from: "



skeleton_enemy: "\nThere is a Skeleton \nWhat will you do?\n (1 == Attack, 2 == Flee)\nEnter your choice:"
goblin_enemy: "\nThere is a Goblin \nWhat will you do?\n (1 == Attack, 2 == Flee)\nEnter your choice:"
location_2: "\nWhile you travel, you see many blue mushrooms in the area. Some say that this mushroom can heal when consumed.\n What will you do.?\n (1 == Pick up Blue Mushroom and eat, 2 = Walk )\n Enter your Choice: "





status_msm: .asciiz "\nNotice: Player Status"
player_hp_msm: .asciiz "\nHealth == "
player_weapon_msm: .asciiz "\nWeapon == "
plyr_name: .space 64


option1: .asciiz "1 == Walk \n2 == View status\nEnter your choice: \n"

## Battle MSM
battle_msm: .asciiz "\nNotice: You are in battle with an enemy...!! \n "

player_attacking_msm: "\nAttacking the enemy...!!\n   Enemy Health: "
attack_msm: .asciiz "\nThe enemy is attacking..!!!\n   Player Health: "

win_msm: .asciiz "\nYou defeated the enemy...!!!\nWeapon DMG increase to: "
lose_msm: .asciiz "\nYou have been defeated by the enemy...!!!\n  GAME OVER...."




## Others
invalid_msm: .asciiz "\nInvalid choice. Enter Again.\n"




.text

main:


	
	li $v0, 4
	la $a0, intro
	syscall

	li $v0, 5
	syscall
	move $t0, $v0
	
	## Handler user Choice
	beq $t0, 1 , game_start
	beq $t0, 2 , quit
	


game_start:
	
	li $v0, 4
	la $a0, loading
	syscall
	li $v0, 32
	li $a0, 4000
	syscall
	
	li $v0, 4
	la $a0, game_intro1
	syscall

	li $v0, 32
	li $a0, 5000
	syscall
		
	li $v0 , 4
	la $a0, player_msm1
	syscall


	li $v0 , 4
	la $a0, game_desc1
	syscall
	
	
	
	li $v0 , 4
	la $a0, option1
	syscall
	
	li $v0, 5
	syscall
	move $t1, $v0
	

	beq $t1, 1 , game_loop
	beq $t1, 2 , player_status
	
game_loop:
	
	lw $t8, enemy_count		## Tracking how many enemy had defeated.
	li $t9, 3			## Enemy Total Need to Defeat
	beq $t8, $t9, end_game	## If Enemy Count is Equal to Enemy Total Need to Defeat.. End of the game 
	
	 
	li $v0 , 4
	la $a0, game_desc2
	syscall
	
	li $v0, 32
	li $a0, 1000
	syscall
		
	
	li $v0 , 4
	la $a0, option1
	syscall

	li $v0, 5
	syscall
	move $t2, $v0
	
	
	beq $t2, 1 , next_path
	beq $t2, 2 , player_status
	
	j invalid
	

next_path:

	li $a1, 10
	li $v0, 42
	syscall
	addi $t3, $a0, 5
	
	
   	beq $t3, 1, enemy2_encounter
	beq $t3, 2, enemy2_encounter
   	beq $t3, 3, game_loop
   	beq $t3, 4, enemy2_encounter
   	beq $t3, 5, location_2_encounter
   	beq $t3, 6, enemy1_encounter
   	beq $t3, 7, location_2_encounter
	beq $t3, 8, enemy1_encounter
   	beq $t3, 9, location_2_encounter
	beq $t3, 10, game_loop



### Encountering Enemy



enemy1_encounter:
    li $v0, 4
    la $a0, goblin_enemy
    syscall

    li $v0, 5
    syscall
    move $t3, $v0

    beq $t3, 1, battle
    beq $t3, 2, game_loop

    j enemy_encounter_invalid


enemy2_encounter:
    li $v0, 4
    la $a0, skeleton_enemy
    syscall

    li $v0, 5
    syscall
    move $t3, $v0

    beq $t3, 1, battle
    beq $t3, 2, game_loop

    j enemy_encounter_invalid




battle:
	
	
	
	la $t4, max_hp
	lw $t5, 0($t4)
	
	la $t6, weapon
	lw $t7, 0($t6)
	       
	la $s0, enemy_hp
	lw $s1, 0($s0)
	
	la $s2, enemy_weapon
	lw $s3, 0($s2)
	
	li $v0, 32
          li $a0, 1000
          syscall
          
	li $v0, 4
	la $a0, battle_msm
	syscall
	
	jal player_attack
	
	blez $s1, win
	
	jal enemy_attack
	
	j battle
	

player_attack:
    sub $s1, $s1, $t7
    sw $s1, 0($s0)
    
    # Print attack prompt and enemy health
    li $v0, 4
    la $a0, player_attacking_msm
    syscall
    
    li $v0, 32
    li $a0, 1000
    syscall
    
    li $v0, 1
    move $a0, $s1
    syscall		## player hp = $t4: $t5
			## Weapon = $t6: $t7
    jr $ra		## Enemy HP = $s0: $s1
			## Enemy Weapon = $s2: $s3

enemy_attack:
    sub $t5, $t5, $s3
    sw $t5, 0($t4)

    # Print enemy attack prompt and player health
    li $v0, 4
    la $a0, attack_msm
    syscall

    li $v0, 32
    li $a0, 1000
    syscall
    

    li $v0, 1
    move $a0, $t5
    syscall

    jr $ra	

enemy_hp_reset:
    lw $s1, enemy_maxhp
    sw $s1, enemy_hp
    
    j game_loop

location_2_encounter:
    li $v0, 4
    la $a0, location_2
    syscall

    li $v0, 32
    li $a0, 1000
    syscall


    li $v0, 5
    syscall
    move $t3, $v0

    beq $t3, 1, heal_player
    beq $t3, 2, game_loop

    j invalid


heal_player:

    la $t4, max_hp
    lw $t5, 0($t4)

    li $a1, 1000 
    li $v0, 42
    syscall
    add $t5, $t5, 253  ## heal player 
    sw $t5, 0($t4)  
    
    li $v0,4
    la $a0, heal_msm
    syscall
    
    li $v0, 1
    move $a0, $t5
    syscall
    
    j game_loop

### PLayer Status
player_status:
	
	li $v0, 4
	la $a0, status_msm
	syscall
	
		
	# Display Player Current HP	
	li $v0, 4
	la $a0, player_hp_msm
	syscall
	
	la $t4, max_hp
	lw $t5, 0($t4)
	
	li $v0, 1
	move $a0, $t5
	syscall
	
	
	li $v0, 4
	la $a0, player_weapon_msm
	syscall
	
	la $t6, weapon
	lw $t7, 0($t6)
	
	move $a0, $t7
	li $v0, 1
	syscall
	
	li $v0, 4
	la $a0, back_msm
	syscall
	
	li $v0, 5
	syscall
	move $t3, $v0

	beq $t3, 1 , game_loop
	
	j invalid

	

####################################################################
###################################################################



invalid:
	li $v0, 4
	la $a0, invalid_msm
	syscall
	j game_loop

enemy_encounter_invalid:
	li $v0, 4
	la $a0, invalid_msm
	syscall
	j enemy1_encounter

win:	
	
	lw $t8, enemy_count	
	addi $t8, $t8, 1		# Increment defeated enemy count
	sw $t8, enemy_count		
	
	li $a2, 50
	li $v0, 42
	add $t7, $t7, 25 		## Weapon DMG Increase randomly 
	sw $t7, 0($t6)
	
	
	li $v0, 4
	la $a0, win_msm
	syscall
	li $v0, 1
	move $a0, $t7
	syscall
	
	li $s6, 0
    	bge $t8, $s6, enemy_hp_reset	## Enemy Max HP Reset
		
	j game_loop	
		

lose:
	li $v0, 4
	la $a0, lose_msm
	syscall
	
	li $v0, 10
	syscall 



end_game:
	li $v0, 4
	la $a0,end_game_msm
	syscall
	
	li $v0, 10
	syscall 



quit:
	li $v0, 10
	syscall
