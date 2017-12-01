--this is a lua script for use in conky
require 'cairo'

function conky_main()
    if conky_window == nil then
        return
    end
    local cs = cairo_xlib_surface_create(conky_window.display,
                                         conky_window.drawable,
                                         conky_window.visual,
                                         conky_window.width,
                                         conky_window.height)
    cr = cairo_create(cs)

--[[
-- LINEA
line_width=10
line_cap=CAIRO_LINE_CAP_BUTT
red,green,blue,alpha=0,1,0,0.5
startx=100
starty=100
endx=150
endy=150
----------------------------
cairo_set_line_width (cr,line_width)
cairo_set_line_cap  (cr, line_cap)
cairo_set_source_rgba (cr,red,green,blue,alpha)
cairo_move_to (cr,startx,starty)
cairo_line_to (cr,endx,endy)
cairo_stroke (cr)
-- FIN LINEA
]]

-- PROCESADORES
line_width=10
line_cap=CAIRO_LINE_CAP_BUTT
red,green,blue,alpha=0,1,1,0.2

center_x1=55
center_x2=165
center_y=220
radius=47
start_angle=0
end_angle=180

cairo_set_line_width (cr,line_width)
cairo_set_line_cap  (cr, line_cap)
cairo_set_source_rgba (cr,red,green,blue,alpha)

cairo_arc (cr,center_x1,center_y,radius,(start_angle-180)*(math.pi/180),(end_angle-180)*(math.pi/180))
cairo_stroke (cr)

cairo_arc (cr,center_x2,center_y,radius,(start_angle-180)*(math.pi/180),(end_angle-180)*(math.pi/180))
cairo_stroke (cr)

line_width=10
line_cap=CAIRO_LINE_CAP_BUTT
red,green,blue,alpha=0,1,1,1

end_angle1=(tonumber(conky_parse("${cpu cpu1}"))*180)/100
end_angle2=(tonumber(conky_parse("${cpu cpu2}"))*180)/100

cairo_set_line_width (cr,line_width)
cairo_set_line_cap  (cr, line_cap)
cairo_set_source_rgba (cr,red,green,blue,alpha)

cairo_arc (cr,center_x1,center_y,radius,(start_angle-180)*(math.pi/180),(end_angle1-180)*(math.pi/180))
cairo_stroke (cr)

cairo_arc (cr,center_x2,center_y,radius,(start_angle-180)*(math.pi/180),(end_angle2-180)*(math.pi/180))
cairo_stroke (cr)

-- FIN PROCESADORES


-- CIRCULO
line_width=10
line_cap=CAIRO_LINE_CAP_BUTT
red,green,blue,alpha=0,1,0,0.2

center_x=60
center_y=460
radius=55
start_angle=0
end_angle=180

cairo_set_line_width (cr,line_width)
cairo_set_line_cap  (cr, line_cap)
cairo_set_source_rgba (cr,red,green,blue,alpha)

cairo_arc (cr,center_x,center_y,radius,(start_angle-180)*(math.pi/180),(end_angle-180)*(math.pi/180))
cairo_stroke (cr)

-- FIN CIRCULO

-- CIRCULO
line_width=10
line_cap=CAIRO_LINE_CAP_BUTT
red,green,blue,alpha=0,1,0,1

end_angle=(tonumber(conky_parse("${memperc}"))*180)/100

cairo_set_line_width (cr,line_width)
cairo_set_line_cap  (cr, line_cap)
cairo_set_source_rgba (cr,red,green,blue,alpha)

cairo_arc (cr,center_x,center_y,radius,(start_angle-180)*(math.pi/180),(end_angle-180)*(math.pi/180))
cairo_stroke (cr)

-- FIN CIRCULO






-- TEXT
font="DejaVu Sans Condensed"
font_size=28

text= conky_parse("${memperc}%")
xpos,ypos=40,460
red,green,blue,alpha=0,1,0,1

font_slant=CAIRO_FONT_SLANT_NORMAL
font_face=CAIRO_FONT_WEIGHT_NORMAL
----------------------------------
cairo_select_font_face (cr, font, font_slant, font_face);
cairo_set_font_size (cr, font_size)
cairo_set_source_rgba (cr,red,green,blue,alpha)
cairo_move_to (cr,xpos,ypos)
cairo_show_text (cr,text)
cairo_stroke (cr)
-- FIN TEXT

-- TEXT

text= conky_parse("${cpu cpu1}%")
xpos,ypos=40,220
red,green,blue,alpha=0,1,1,1

font_slant=CAIRO_FONT_SLANT_NORMAL
font_face=CAIRO_FONT_WEIGHT_NORMAL
----------------------------------
cairo_select_font_face (cr, font, font_slant, font_face);
cairo_set_font_size (cr, font_size)
cairo_set_source_rgba (cr,red,green,blue,alpha)
cairo_move_to (cr,xpos,ypos)
cairo_show_text (cr,text)
cairo_stroke (cr)
-- FIN TEXT

-- TEXT

text= conky_parse("${cpu cpu2}%")
xpos,ypos=150,220
red,green,blue,alpha=0,1,1,1

font_slant=CAIRO_FONT_SLANT_NORMAL
font_face=CAIRO_FONT_WEIGHT_NORMAL
----------------------------------
cairo_select_font_face (cr, font, font_slant, font_face);
cairo_set_font_size (cr, font_size)
cairo_set_source_rgba (cr,red,green,blue,alpha)
cairo_move_to (cr,xpos,ypos)
cairo_show_text (cr,text)
cairo_stroke (cr)
-- FIN TEXT

    cairo_destroy(cr)
    cairo_surface_destroy(cs)
    cr=nil
end

