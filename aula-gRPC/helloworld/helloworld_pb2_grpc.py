# Generated by the gRPC Python protocol compiler plugin. DO NOT EDIT!
"""Client and server classes corresponding to protobuf-defined services."""
import grpc
import warnings

import helloworld.helloworld_pb2 as helloworld__pb2

GRPC_GENERATED_VERSION = '1.71.0'
GRPC_VERSION = grpc.__version__
_version_not_supported = False

try:
    from grpc._utilities import first_version_is_lower
    _version_not_supported = first_version_is_lower(GRPC_VERSION, GRPC_GENERATED_VERSION)
except ImportError:
    _version_not_supported = True

if _version_not_supported:
    raise RuntimeError(
        f'The grpc package installed is at version {GRPC_VERSION},'
        + f' but the generated code in helloworld_pb2_grpc.py depends on'
        + f' grpcio>={GRPC_GENERATED_VERSION}.'
        + f' Please upgrade your grpc module to grpcio>={GRPC_GENERATED_VERSION}'
        + f' or downgrade your generated code using grpcio-tools<={GRPC_VERSION}.'
    )


class GreeterStub(object):
    """Definição do serviço
    """

    def __init__(self, channel):
        """Constructor.

        Args:
            channel: A grpc.Channel.
        """
        self.SayHello = channel.unary_unary(
                '/helloworld.Greeter/SayHello',
                request_serializer=helloworld__pb2.HelloRequest.SerializeToString,
                response_deserializer=helloworld__pb2.HelloReply.FromString,
                _registered_method=True)
        self.LotsOfReplies = channel.unary_stream(
                '/helloworld.Greeter/LotsOfReplies',
                request_serializer=helloworld__pb2.HelloRequest.SerializeToString,
                response_deserializer=helloworld__pb2.HelloReply.FromString,
                _registered_method=True)
        self.LotsOfGreetings = channel.stream_unary(
                '/helloworld.Greeter/LotsOfGreetings',
                request_serializer=helloworld__pb2.HelloRequest.SerializeToString,
                response_deserializer=helloworld__pb2.HelloReply.FromString,
                _registered_method=True)
        self.BidiHello = channel.stream_stream(
                '/helloworld.Greeter/BidiHello',
                request_serializer=helloworld__pb2.HelloRequest.SerializeToString,
                response_deserializer=helloworld__pb2.HelloReply.FromString,
                _registered_method=True)


class GreeterServicer(object):
    """Definição do serviço
    """

    def SayHello(self, request, context):
        """Chamada RPC simples
        """
        context.set_code(grpc.StatusCode.UNIMPLEMENTED)
        context.set_details('Method not implemented!')
        raise NotImplementedError('Method not implemented!')

    def LotsOfReplies(self, request, context):
        """Chamada com streaming de resposta
        """
        context.set_code(grpc.StatusCode.UNIMPLEMENTED)
        context.set_details('Method not implemented!')
        raise NotImplementedError('Method not implemented!')

    def LotsOfGreetings(self, request_iterator, context):
        """Chamada com streaming de requisição
        """
        context.set_code(grpc.StatusCode.UNIMPLEMENTED)
        context.set_details('Method not implemented!')
        raise NotImplementedError('Method not implemented!')

    def BidiHello(self, request_iterator, context):
        """Chamada com streaming bidirecional
        """
        context.set_code(grpc.StatusCode.UNIMPLEMENTED)
        context.set_details('Method not implemented!')
        raise NotImplementedError('Method not implemented!')


def add_GreeterServicer_to_server(servicer, server):
    rpc_method_handlers = {
            'SayHello': grpc.unary_unary_rpc_method_handler(
                    servicer.SayHello,
                    request_deserializer=helloworld__pb2.HelloRequest.FromString,
                    response_serializer=helloworld__pb2.HelloReply.SerializeToString,
            ),
            'LotsOfReplies': grpc.unary_stream_rpc_method_handler(
                    servicer.LotsOfReplies,
                    request_deserializer=helloworld__pb2.HelloRequest.FromString,
                    response_serializer=helloworld__pb2.HelloReply.SerializeToString,
            ),
            'LotsOfGreetings': grpc.stream_unary_rpc_method_handler(
                    servicer.LotsOfGreetings,
                    request_deserializer=helloworld__pb2.HelloRequest.FromString,
                    response_serializer=helloworld__pb2.HelloReply.SerializeToString,
            ),
            'BidiHello': grpc.stream_stream_rpc_method_handler(
                    servicer.BidiHello,
                    request_deserializer=helloworld__pb2.HelloRequest.FromString,
                    response_serializer=helloworld__pb2.HelloReply.SerializeToString,
            ),
    }
    generic_handler = grpc.method_handlers_generic_handler(
            'helloworld.Greeter', rpc_method_handlers)
    server.add_generic_rpc_handlers((generic_handler,))
    server.add_registered_method_handlers('helloworld.Greeter', rpc_method_handlers)


 # This class is part of an EXPERIMENTAL API.
class Greeter(object):
    """Definição do serviço
    """

    @staticmethod
    def SayHello(request,
            target,
            options=(),
            channel_credentials=None,
            call_credentials=None,
            insecure=False,
            compression=None,
            wait_for_ready=None,
            timeout=None,
            metadata=None):
        return grpc.experimental.unary_unary(
            request,
            target,
            '/helloworld.Greeter/SayHello',
            helloworld__pb2.HelloRequest.SerializeToString,
            helloworld__pb2.HelloReply.FromString,
            options,
            channel_credentials,
            insecure,
            call_credentials,
            compression,
            wait_for_ready,
            timeout,
            metadata,
            _registered_method=True)

    @staticmethod
    def LotsOfReplies(request,
            target,
            options=(),
            channel_credentials=None,
            call_credentials=None,
            insecure=False,
            compression=None,
            wait_for_ready=None,
            timeout=None,
            metadata=None):
        return grpc.experimental.unary_stream(
            request,
            target,
            '/helloworld.Greeter/LotsOfReplies',
            helloworld__pb2.HelloRequest.SerializeToString,
            helloworld__pb2.HelloReply.FromString,
            options,
            channel_credentials,
            insecure,
            call_credentials,
            compression,
            wait_for_ready,
            timeout,
            metadata,
            _registered_method=True)

    @staticmethod
    def LotsOfGreetings(request_iterator,
            target,
            options=(),
            channel_credentials=None,
            call_credentials=None,
            insecure=False,
            compression=None,
            wait_for_ready=None,
            timeout=None,
            metadata=None):
        return grpc.experimental.stream_unary(
            request_iterator,
            target,
            '/helloworld.Greeter/LotsOfGreetings',
            helloworld__pb2.HelloRequest.SerializeToString,
            helloworld__pb2.HelloReply.FromString,
            options,
            channel_credentials,
            insecure,
            call_credentials,
            compression,
            wait_for_ready,
            timeout,
            metadata,
            _registered_method=True)

    @staticmethod
    def BidiHello(request_iterator,
            target,
            options=(),
            channel_credentials=None,
            call_credentials=None,
            insecure=False,
            compression=None,
            wait_for_ready=None,
            timeout=None,
            metadata=None):
        return grpc.experimental.stream_stream(
            request_iterator,
            target,
            '/helloworld.Greeter/BidiHello',
            helloworld__pb2.HelloRequest.SerializeToString,
            helloworld__pb2.HelloReply.FromString,
            options,
            channel_credentials,
            insecure,
            call_credentials,
            compression,
            wait_for_ready,
            timeout,
            metadata,
            _registered_method=True)
