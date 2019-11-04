module CDSPlotUtils

using Plots

# course-wide plotting defaults
gr(
    label="",
    markerstrokewidth=0.3,
    markerstrokecolor=:white,
    alpha=0.8
)

"""
    p = imshow(img; kwargs...)

Return a grayscale heatmap of the matrix `img` with axes and colorbar turned off. Useful for quickly showing a matrix as an image (perhaps with a title added).
"""
function imshow(img::Matrix; kwargs...)
    return heatmap(
        img;
        yflip=true,
        color=:grays,
        showaxis=false,
        grid=false,
        colorbar=false,
        aspect_ratio=:equal,
        kwargs...
    )
end

"Draw an arrow, using a polar projection, from (x1, y1) to (x2, y2)."
function add_polar_arrow!(x1x2::Vector, y1y2::Vector; kwargs...)
    return plot!(
        x1x2, y1y2;
        seriestype=:path,
        proj=:polar,
        arrow=0.4,
        kwargs...
    )
end

"""
    p = joyplot(A)

Generate a "joyplot" from data in `A`. Each column of `A` will be
plotted with a `plot()` command, and all plots will be stacked
vertically.

Keyword arguments:
* `labels`: a vector of subplot labels having length size(A, 2).
* `plot_size`: overall plot size; default is (400, 500).
* `subplot_scale`: level of overlap between subplots; default is 1.0.
* `color`: vector of colors with length size(A, 2).
"""
function joyplot(
        A::Matrix;
        labels=1:size(A, 2),
        plot_size=(400, 500),
        subplot_scale::Float64=1.0,
        color=distinguishable_colors(size(A, 2) + 2)[3:end]
    )
    m, n = size(A)
    subplot_height = subplot_scale / n
    subplot_y = range(0; stop=(1 - subplot_height), length=n)

    p = plot(;
        size=plot_size,
        yticks=(subplot_y, labels),
        grid=:x
    )

    peak = maximum(A)

    for i in 1:n
        plot!(
            A[:, i];
            inset=(1, bbox(-0.025, subplot_y[i], 1.05, subplot_height, :bottom, :left)),
            subplot=i + 1,
            bg_inside=nothing,
            framestyle=:none,
            fillrange=0,
            fillalpha=0.5,
            fillcolor=color[i],
            color=color[i],
            ylim=(0, peak * 1.1)
        )
    end
    return p
end

end # module
