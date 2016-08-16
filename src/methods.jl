"""
`next!(p, [color])` reports that one unit of progress has been
made. Depending on the time interval since the last update, this may
or may not result in a change to the display.
You may optionally change the color of the display. See also `update!`.
"""
function next!(p::ProgressContinue; options...)
    p.counter += 1
    updateProgress!(p; options...)
end

"""
`cancel(p, [msg], [color=:red])` cancels the progress display
before all tasks were completed. Optionally you can specify the
message printed and its color.
See also `finish!`.
"""
function cancel(p::ProgressContinue, msg::AbstractString = "Aborted before all tasks were completed", color = :red; showvalues = Any[], valuecolor = :blue)
    if p.printed
        move_cursor_up_while_clearing_lines(p.output, p.numprintedvalues)
        printover(p.output, msg, color)
        printvalues!(p, showvalues; color = valuecolor)
        println(p.output)
    end
    return
end

"""
`finish!(p)` indicates that all tasks have been completed.
See also `cancel`.
"""
function finish!(p::Progress; options...)
    update!(p; p.counter; options...)
end