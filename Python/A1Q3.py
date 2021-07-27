#Create a python script that will calculate/display:
# Names, types and sizes of blobs in a certain container
# Names and sizes of “folders” in a certain container
# connection_string =
# "DefaultEndpointsProtocol=https;AccountName=antrablobstorage;AccountKey=E
# CVP9sDWl64Ubd6w3lGd4d4fbiZuwHWWu1q/KoS2sCR18mwwkSxf1gLC7PvqC
# T1jWi3IYE87ZQtJYMIztIg3vg==;EndpointSuffix=core.windows.net"
# container_name = "imagescontainer"

connection_string = '''
DefaultEndpointsProtocol=https;AccountName=antrablobstorage;AccountKey=E
CVP9sDWl64Ubd6w3lGd4d4fbiZuwHWWu1q/KoS2sCR18mwwkSxf1gLC7PvqC
T1jWi3IYE87ZQtJYMIztIg3vg==;EndpointSuffix=core.windows.net'''

container_name = 'imagescontainer'

container = ContainerClient.from_connection_string(conn_str = connection_string, container_name = container_name)

