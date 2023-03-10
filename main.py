import numpy as np
import tkinter as tk
import customtkinter as ctk
from PIL import ImageTk, Image
import cv2

# Init tkinter
ctk.set_appearance_mode("System")
ctk.set_default_color_theme("blue")
window = ctk.CTk()

# Init frames
src_frame = ctk.CTkFrame(master=window, width=480, height=640)
dst_frame = ctk.CTkFrame(master=window, width=480, height=640)

# Window Control functions
def button_process_pressed():
    filetypes = [('Image files', '*.jpg')]
    file_path = ctk.filedialog.askopenfilename(
        title='Open source file...',
        initialdir='./data/',
        filetypes=filetypes
    )
    #TODO: Clip image
    img = ctk.CTkImage(Image.open(file_path),size=(480, 640))
    img_label = ctk.CTkLabel(master=src_frame, image=img)
    img_label.pack()

def main():
    window.title('CVLightPass')
    window.geometry('1280x660')
    # Create image stack panel
    #TODO:Move init window control into another class
    src_frame.pack(side='left', padx=10, pady=10)
    dst_frame.pack(side='left', padx=0, pady=10)
    
    button_process = ctk.CTkButton(master=window, text="开始处理", command=button_process_pressed)
    button_process.pack()
    #testimg = cv2.imread('./data/testimg.jpg')
    window.mainloop()
    #cv2.imshow('testimage', testimg)
    #cv2.waitKey(0)
    pass


if __name__ == '__main__':
    # call main function
    main()