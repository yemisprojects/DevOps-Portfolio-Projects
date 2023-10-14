################################################Prerequisite/Usage###########################################################
# This script requires a json input file generated using the aws cli command below. 
#      aws glacier get-job-output --vault-name <vault_name> --account-id <account-id> --job-id <jobID> output.json
# It extracts the archive IDs, splits them into a specified number of files and saves them under a folder named "archives"
#       Usage: python generate_split_files.py -i <json_file> -n <num_split_files>
############################################################################################################################
import json
import os
import sys
import getopt

archive_file = "archiveid.txt"
archive_dir = "archives" 

def generate_archive_ids(input_file):
    """
    It reads the job output file and writes the archive ids to a file
    
    :param input_file: The name of the json file that contains the list of archives
    """

    print(f"Loading json file {input_file}...........")
    with open (input_file, "r") as f:
        job_output = json.loads(f.read())
    archives = job_output['ArchiveList']

    if os.path.exists(archive_file):                        
        id = open(archive_file,"w")
        id.close()
    with open(archive_file,"a") as id:
        print(f"\nWriting the list of archive ids to {archive_file} into current working directory......\n")
        for archive in archives:
            id.write(archive['ArchiveId']+"\n")

def create_archive_folder():
    """
    It creates a new folder in the current working directory, and if the 
    folder already exists, it deletes all the files in it

    :return: The path to the archive folder.
    """

    archive_path = os.getcwd() + os.sep + archive_dir
    print(f"\nCreating a new folder in {os.getcwd()}....")

    if not os.path.exists(archive_path):
        os.mkdir(archive_path)

    if len(os.listdir(archive_path)) > 0:                  
        for f in os.listdir(archive_path):
            os.remove(os.path.join(archive_path, f))
    
    return archive_path

def split_files(archive_path,num_of_split_files):            
    """
    The function takes in an absolute folder path and the number of split files as arguments. It
    then reads the archive file and splits it into multiple files based on the number of split files
    
    :param archive_path: The path to the folder where the archive file is located
    :param num_of_split_files: The number of files you want to split the archive file into
    """

    with open(archive_file,'r') as files:
        lines = files.readlines()
    print(f'\n{archive_file} has {len(lines)} lines')

    file_num = 0
    num_to_read = len(lines) // num_of_split_files
    start = 0
    end = num_to_read

    print(f"Splitting {archive_file} into multiple files in {archive_path} folder.....")  

    while True:
        file_num += 1
        with open(f"{os.getcwd()}{os.sep}{archive_dir}{os.sep}file{file_num}.txt",'a') as newfile:
            for line in lines[start:end]: 
                newfile.write(line)
        if file_num == num_of_split_files + 1: break
        start += num_to_read
        end += num_to_read

    print(f"Files are saved into {archive_path}")

def get_input(argv):
    """
    The function reads the user's input, validates it and
    then returns the input file and the number of split files to generate
    
    :param argv: This is the list of command-line arguments.
    :return: the input file and the number of split files to generate.
    """

    input_file = ""  
    num_of_split_files = ""
    arg_help = f"Usage: python {argv[0]} -i <input_json_file> -n <num_split_files>"

    if len(argv) == 1:
        print(f"Script requires two arguments. See usage below\n{arg_help}")
        sys.exit(2)
    else:
        try:
            opts, args = getopt.getopt(argv[1:], "hi:n:o:", ["help", "input_file=", "num_files="]) 
        except:
            print(arg_help)
            sys.exit(2)
        for opt, arg in opts:
            if opt in ("-h", "--help"):
                print(arg_help)
                sys.exit(2)
            elif opt in ("-i", "--input_file"):
                input_file = arg
                print("Input file: ", input_file )
            elif opt in ("-n", "--num_files"):
                try:
                    if isinstance(int(arg), int):
                        num_of_split_files = int(arg)
                        print("Number of split files to generate: ", num_of_split_files)
                except:
                    print(f"{arg_help}\n<num_split_files> should be a number\n")
                    sys.exit(2)

        if input_file and num_of_split_files:
            return input_file, num_of_split_files
        else:
            print(f"Script requires two arguments. See usage below\n{arg_help}")
            sys.exit(2)

if __name__ == "__main__":
    try:
        input_file, num_of_split_files = get_input(sys.argv)
        generate_archive_ids(input_file)
        archive_path = create_archive_folder()
        split_files(archive_path,num_of_split_files)
    except Exception as error:
        print("There was a failure generating the split files")
        print(error)
