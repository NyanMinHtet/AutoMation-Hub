import os
import shutil


def delete_pycache(folder_path):
    # Walk through the directory tree
    for root, dirs, files in os.walk(folder_path):
        for dir_name in dirs:
            # Check if the directory is __pycache__
            if dir_name == "__pycache__":
                pycache_path = os.path.join(root, dir_name)
                print(f"Deleting {pycache_path}")
                # Delete the __pycache__ directory
                shutil.rmtree(pycache_path)


if __name__ == "__main__":
    # Replace with the path to the folder where you want to delete __pycache__ directories
    target_folder = "/home/nyanminhtet/odoo/odoo-15.0.post20240809/"
    target_folder2 = "/home/nyanminhtet/odoo/odoo-15.0+e.20240907"
    target_folder3 = "/home/nyanminhtet/odoo/odoo-17.0+e.20241223/"
    target_folder4 = "/home/nyanminhtet/odoo/odoo-16.0+e.20240922"
    target_folder5 = "/home/nyanminhtet/odoo/odoo-13.0EE/odoo-13.0EE"
    target_folder6 = "/home/nyanminhtet/odoo/odoo-16.0.post20241012"
    target_folder7 = "/home/nyanminhtet/GitHub/DEV/value-distribution"

    delete_pycache(target_folder7)
