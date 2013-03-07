import os.path

results_dir = """/vol/bitbucket/tr111/Prolog-War-of-Life/results"""

strategies = ["minimax", "bloodlust", "random", "land_grab", "self_preservation"]

info = {}

def print_strategy(strategy1, strategy2):
	files = []
	info = {}
	info["Player 1 Wins"] = 0
	info["Player 2 Wins"] = 0
        info["Number of Draws"] = 0
	info["Longest Game"] = 0
	info["Shortest Game"] = 0
	info["Average Game Length"] = 0
	info["Average Game Time"] = 0
	info["total_games"] = 0
	file_name_base = results_dir + '/' + str(strategy1) + '_' + str(strategy2)
	i = 0
	print "Base: ", file_name_base
	for i in range(0,1000):
		if os.path.isfile(file_name_base+str(i)):
			files.append(file_name_base+str(i))
	for file_name in files:
		with open(file_name) as f:
			data = f.read()
		data = data.split('\n')
		data = [n.split(':') for n in data]
		if len(data) < 6: continue
		data = data[1:-1]
		print data
		info[data[0][0]] = data[0][1]
		info[data[1][0]] = data[1][1]
		info[data[2][0]] = int(info[data[2][0]]) + int(data[2][1].split(' ')[1])
		info[data[3][0]] = int(info[data[3][0]]) + int(data[3][1].split(' ')[1])
		info[data[4][0]] = int(info[data[4][0]]) + int(data[4][1].split(' ')[1])
		info[data[5][0]] = max(int(info[data[5][0]]), int(data[5][1].split(' ')[1]))
		info[data[6][0]] = min(int(info[data[6][0]]), int(data[6][1].split(' ')[1]))
#		info[data[6][0]] = min(int(info[data[5][0]]), int(data[5][1]))
		total_games = int(data[2][1].split(' ')[1]) + int(data[3][1].split(' ')[1]) + int(data[4][1].split(' ')[1])
		tmp1 = (info[data[7][0]] * info["total_games"] + float(data[7][1].split(' ')[1]) * total_games)
		tmp2 = (info[data[8][0]] * info["total_games"] + float(data[8][1].split(' ')[1]) * total_games)
		info["total_games"] += total_games
		info[data[7][0]] = tmp1 / info["total_games"]
		info[data[8][0]] = tmp2 / info["total_games"]
	print info

if __name__ == "__main__":
	print "Import me!"
