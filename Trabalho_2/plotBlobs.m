function x = plotBlobs(blobs, im)

    idisp(im);
    for i=1:numel(blobs)
        plot_box(blobs(i).umin, blobs(i).vmin, blobs(i).umax, blobs(i).vmax, 'g');
    end