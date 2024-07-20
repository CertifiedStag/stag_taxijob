# Taxi Job!
Player Ran Taxi Job with command for alerts, a built in billing system and duty system.

# Dependencies
- qb-core
- qb/ox target
- qb-input

# Add to shared/jobs.lua

```taxijob = {
		label = "Taxi Driver",
		defaultDuty = true,
		offDutyPay = false,
		grades = {
			['0'] = { name = "Trainee", payment = 50 },
			['1'] = { name = "Employee", payment = 75 },
			['2'] = { name = "Supervisor", payment = 100 },
			['3'] = { name = "Head Supervisor", payment = 125 },
			['4'] = { name = "Owner", isboss = true, payment = 150 },
		},
	},
