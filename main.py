import numpy as np
import tkinter as tk
import customtkinter as ctk
import cv2

# Init tkinter
ctk.set_appearance_mode("System")
ctk.set_default_color_theme("blue")
window = ctk.CTk()


def main():
    window.title('CVLightPass')
    window.geometry('1280x660')
    # Create image stack panel
    src_frame = ctk.CTkFrame(master=window, width=480, height=640)
    dst_frame = ctk.CTkFrame(master=window, width=480, height=640)
    src_frame.pack(side='left', padx=10, pady=10)
    dst_frame.pack(side='left', padx=0, pady=10)
    
    #testimg = cv2.imread('./data/testimg.jpg')
    window.mainloop()
    #cv2.imshow('testimage', testimg)
    #cv2.waitKey(0)
    pass


if __name__ == '__main__':
    # call main function
    main()