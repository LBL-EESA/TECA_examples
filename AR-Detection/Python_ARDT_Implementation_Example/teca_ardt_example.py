import numpy as np
from teca import *
import copy

def ar_detect_basic(ivt, lat ,lon):
    """ Implements a rudimentary AR detector that thresholds IVT at 250 kg/m/s and filters the tropics. """

    # create 2D lat/lon fields
    lon2d, lat2d = np.meshgrid(lon, lat)

    # find points where latitude is less than 15 degrees absolute
    i_lat_filter = np.nonzero(np.abs(lat2d.ravel()) < 15)[0]

    # set IVT to zero at those points
    ivt_detect = copy.deepcopy(ivt)
    ivt_detect.ravel()[i_lat_filter] = 0.0

    # threshold ivt
    ar_tag = ivt_detect >= 250

    # return the AR tag
    return ar_tag

class teca_ardt_example(teca_python_algorithm):

    ivt_variable = "ivt"
    output_variable = "ar_binary_tag"
    def set_ivt_variable(self, variable):
        """ Sets the IVT variable name"""
        self.ivt_variable = variable

    def report(self, o_port, reports_in):
        # add the variable we proeduce to the report
        rep = teca_metadata(reports_in[0])

        if rep.has('variables'):
            rep.append('variables', self.output_variable)
        else:
            rep.set('variables', self.output_variable)


        # set the output variable attributes
        output_variable_atts = teca_array_attributes(
                teca_float_array_code.get(),
                teca_array_attributes.point_centering,
                0, 'unitless', 'AR binary tag',
                'a binary value indicating presence of an '
                'an atmospheric river (1=AR present, 0=not)',
                None)
        attributes = rep["attributes"]
        attributes[self.output_variable] = output_variable_atts.to_metadata()
        rep["attributes"] = attributes

        return rep

    def request(self, o_port, reports_in, request_in):
        # request IVT from the upstream pipeline stages
        req = teca_metadata(request_in)
        req['arrays'] = [self.ivt_variable]
        return [req]

    def execute(self, o_port, data_in, request_in):
        """ Implements a rudimentary AR detector that thresholds at 250 kg/m/s and avoids the tropics. """
        # get the input array
        in_mesh = as_teca_cartesian_mesh(data_in[0])
        if in_mesh is None:
            raise RuntimeError('empty input, or not a mesh')
        arrays = in_mesh.get_point_arrays()
        ivt = arrays[self.ivt_variable]

        # get the x and y coordinates
        lon = in_mesh.get_x_coordinates()
        lat = in_mesh.get_y_coordinates()

        # reshape the ivt array to 2D
        ivt = np.reshape(ivt, (len(lat), len(lon)))

        # call the AR detector
        ar_tag = ar_detect_basic(ivt, lat, lon)

        # build the output mesh
        out_mesh = teca_cartesian_mesh.New()
        out_mesh.shallow_copy(in_mesh)

        # add the output variable to the output mesh
        out_va = teca_variant_array.New(ar_tag.astype(np.float32))
        out_mesh.get_point_arrays().set(self.output_variable, out_va)

        return out_mesh