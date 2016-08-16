VERSION >= v"0.4.0-dev+6521" && __precompile__()

module ProgressMeterPlus

using ProgressMeter

export ProgressContinue

include("util.jl")

"""
`prog = Progress(dt=0.1, desc="Progress: ", color=:green,
output=STDOUT, barlen=tty_width(desc))` creates a progress meter for a
task with unknown iterations or stages. Output will be generated at
intervals at least `dt` seconds apart, and perhaps longer if each
iteration takes longer than `dt`. `desc` is a description of
the current task.
"""
type ProgressContinue
    dt::Float64
    counter::Int
    tfirst::Float64
    tlast::Float64
    printed::Bool           # true if we have issued at least one status update
    desc::AbstractString    # prefix to the percentage, e.g.  "Computing..."
    barlen::Int             # progress bar size (default is available terminal width)
    barglyphs::BarGlyphs    # the characters to be used in the bar
    color::Symbol           # default to green
    output::IO              # output stream into which the progress is written
    numprintedvalues::Int   # num values printed below progress in last iteration

    function Progress(; dt::Real=0.1,
                      desc::AbstractString="Progress: ",
                      color::Symbol=:green,
                      output::IO=STDOUT,
                      barlen::Integer=tty_width(desc),
                      barglyphs::BarGlyphs=ProgressMeter.BarGlyphs('|','█','█',' ','|'))
        counter = 0
        tfirst = tlast = time()
        printed = false
        new(dt, counter, tfirst, tlast, printed, desc, barlen, barglyphs, color, output, 0)
    end
end

ProgressContinue(dt::Real, desc::AbstractString="Progress: ",
         barlen::Integer=0, color::Symbol=:green, output::IO=STDOUT) =
    ProgressContinue(dt=dt, desc=desc, barlen=barlen, color=color, output=output)

ProgressContinue(desc::AbstractString) = ProgressContinue(desc=desc)

include("update.jl")
include("methods.jl")

end