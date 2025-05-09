package circle

import "core:fmt"
import "core:os"
import gl "vendor:OpenGL"
import SDL "vendor:sdl2"

WINDOW_WIDTH, WINDOW_HEIGHT :: 640, 640

GL_VERSION_MAJOR, GL_VERSION_MINOR :: 3, 3

main :: proc() {
	SDL.Init({})
	defer SDL.Quit()
	
	window := SDL.CreateWindow(
		"circle",
		SDL.WINDOWPOS_UNDEFINED,
		SDL.WINDOWPOS_UNDEFINED,
		WINDOW_WIDTH,
		WINDOW_HEIGHT,
		{.OPENGL, .RESIZABLE}
	)

	if window == nil {
		fmt.eprintln("no window mam")
		os.exit(1)
	}
	defer SDL.DestroyWindow(window)

	SDL.GL_SetAttribute(.CONTEXT_PROFILE_MASK, i32(SDL.GLprofile.CORE))
	SDL.GL_SetAttribute(.CONTEXT_MAJOR_VERSION, GL_VERSION_MAJOR)
	SDL.GL_SetAttribute(.CONTEXT_MINOR_VERSION, GL_VERSION_MINOR)

	gl_context := SDL.GL_CreateContext(window)
	defer SDL.GL_DeleteContext(gl_context)

	gl.load_up_to(GL_VERSION_MAJOR, GL_VERSION_MINOR, SDL.gl_set_proc_address)

	gl.Enable(gl.BLEND)
	gl.BlendFunc(gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA)

	vao: u32
	gl.GenVertexArrays(1, &vao)
	defer gl.DeleteVertexArrays(1, &vao)
	gl.BindVertexArray(vao)

	vert_src, frag_src :=
		#load("shaders/circle.vert", string), #load("shaders/circle.frag", string)

	program, program_ok := gl.load_shaders_source(vert_src, frag_src)
	if !program_ok {
		fmt.eprintln("no program mam")
		os.exit(1)
	}
	defer gl.DeleteProgram(program)

	gl.UseProgram(program)

	uniforms := gl.get_uniforms_from_program(program)
	defer delete(uniforms)

	width, height :i32= WINDOW_WIDTH, WINDOW_HEIGHT
	gl.Uniform2f(uniforms["resolution"].location, f32(width), f32(height))

	loop: for {
		event: SDL.Event
		for SDL.PollEvent(&event) {
			#partial switch event.type {
			case .KEYDOWN:
				#partial switch event.key.keysym.sym {
				case .ESCAPE:
					break loop
				}
			case .QUIT:
				break loop
			} 
		}

		{
			w, h: i32
			SDL.GetWindowSize(window, &w, &h)
			if w != width || h != height {
				gl.Viewport(0, 0, w, h)
				gl.Uniform2f(uniforms["resolution"].location, f32(width), f32(height))
				width, height = w, h
			}
		}

		gl.ClearColor(0.0, 0.0, 0.0, 1.0)
		gl.Clear(gl.COLOR_BUFFER_BIT)

		gl.DrawArrays(gl.TRIANGLE_STRIP, 0, 4)

		SDL.GL_SwapWindow(window)
	}
}
