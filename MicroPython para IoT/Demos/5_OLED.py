from machine import Pin, I2C
import ssd1306


i2c = I2C(-1, scl=Pin(5), sda=Pin(4))

oled_width = 128
oled_height = 64
oled = ssd1306.SSD1306_I2C(oled_width, oled_height, i2c)




oled.text('Code Camp', 0, 5)
oled.text('Guatemala 2021', 0, 20)



oled.show()

