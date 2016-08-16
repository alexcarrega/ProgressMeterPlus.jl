function updateProgress!(p::ProgressContinue; showvalues = Any[], valuecolor = :blue)
    t = time()
    if t > p.tlast+p.dt
        bar = barstring(p.barlen, p.counter, barglyphs=p.barglyphs)
        elapsed_time = t - p.tfirst
        et_sec = round(Int, elapsed_time)
        et = durationstring(et_sec)
        msg = @sprintf "%s%3u%%%s  ET: %s" p.desc round(Int, p.counter) bar et
        move_cursor_up_while_clearing_lines(p.output, p.numprintedvalues)
        printover(p.output, msg, p.color)
        printvalues!(p, showvalues; color = valuecolor)
        # Compensate for any overhead of printing. This can be
        # especially important if you're running over a slow network
        # connection.
        p.tlast = t + 2*(time()-t)
        p.printed = true
    end
end

"""
`update!(p, counter, [color])` sets the progress counter to
`counter`, relative to the `n` units of progress specified when `prog`
was initialized.  Depending on the time interval since the last
update, this may or may not result in a change to the display.
If `prog` is a `ProgressThresh`, `update!(prog, val, [color])` specifies
the current value.
You may optionally change the color of the display. See also `next!`.
"""
function update!(p::ProgressContinue, counter::Int; options...)
    p.counter = counter
    updateProgress!(p; options...)
end

function update!(p::ProgressContinue, counter::Int, color::Symbol; options...)
    p.color = color
    update!(p, counter; options...)
end