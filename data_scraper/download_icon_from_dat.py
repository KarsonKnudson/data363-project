import os
import json
import requests

# Iterate through all '.dat' files within/below current directory
for root, dirs, files in os.walk("."):
    for filename in files:
        if filename[-4::] == '.dat':
            # Load data file in JSON format
            with open(os.path.join(root, filename)) as json_file:
                data = json.load(json_file)
            
            # Create working path to store image downloads
            new_path = os.path.join(root, filename[0:-4])
            if not os.path.exists(new_path):
                os.makedirs(new_path)
           
            # Download all app icons
            print("+ Working on category " + filename[0:-4] + ':')
            for i in range (0, len(data)):
                print("\t[" + str(i) + "/" + str(len(data)) + "] " + "Downloading icon of " + (data[i])['appId'])
                appId = (data[i])['appId']
                url = (data[i])['icon']
                installs = (data[i])['installs']
                r = requests.get(url, allow_redirects=True)
                open(new_path + '\\' + appId + '_' + str(installs) + '.ico', 'wb').write(r.content)