local MatrixGridHelper = {}

function MatrixGridHelper.calculate_cell_padding(grid_index, small_padding, big_padding, big_padding_interval)
    local padding_count = grid_index - 1
    local big_padding_count = math.floor(padding_count / big_padding_interval)
    local base_padding_count = padding_count - big_padding_count

    return base_padding_count * small_padding + big_padding * big_padding_count
end

return MatrixGridHelper